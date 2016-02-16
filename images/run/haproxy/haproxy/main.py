import logging
import os
import signal
import sys

import tutum

from haproxy import Haproxy
from parser import parse_uuid_from_resource_uri

__version__ = "0.2.4"
tutum.user_agent = "tutum-haproxy/%s" % __version__

DEBUG = os.getenv("DEBUG", False)
PIDFILE = "/tmp/tutum-haproxy.pid"

logger = logging.getLogger("haproxy")


def run_haproxy(msg=None):
    logger.info("==========BEGIN==========")
    if msg:
        logger.info(msg)
    haproxy = Haproxy()
    haproxy.update()


def tutum_event_handler(event):
    logger.debug(event)
    logger.debug(Haproxy.cls_linked_services)
    # When service scale up/down or container start/stop/terminate/redeploy, reload the service
    if event.get("state", "") not in ["In progress", "Pending", "Terminating", "Starting", "Scaling", "Stopping"] and \
                    event.get("type", "").lower() in ["container", "service"] and \
                    len(set(Haproxy.cls_linked_services).intersection(set(event.get("parents", [])))) > 0:
        msg = "Tutum event: %s %s is %s" % (
            event["type"], parse_uuid_from_resource_uri(event.get("resource_uri", "")), event["state"].lower())
        run_haproxy(msg)

    # Add/remove services linked to haproxy
    if event.get("state", "") == "Success" and Haproxy.cls_service_uri in event.get("parents", []):
        run_haproxy()


def create_pid_file():
    pid = str(os.getpid())
    try:
        file(PIDFILE, 'w').write(pid)
    except Exception as e:
        logger.error("Cannot write to pidfile: %s" % e)
    return pid


def user_reload_haproxy(signum, frame):
    run_haproxy("User reload")


def main():
    logging.basicConfig(stream=sys.stdout)
    logging.getLogger("haproxy").setLevel(logging.DEBUG if DEBUG else logging.INFO)

    pid = create_pid_file()
    signal.signal(signal.SIGUSR1, user_reload_haproxy)
    signal.signal(signal.SIGTERM, sys.exit)

    if Haproxy.cls_container_uri and Haproxy.cls_service_uri:
        if Haproxy.cls_tutum_auth:
            logger.info(
                    "Tutum-haproxy %s (PID: %s) has access to Tutum API - will reload list of backends in real-time" % (
                        __version__, pid))
        else:
            logger.warning(
                    "Tutum-haproxy %s (PID: %s) doesn't have access to Tutum API and it's running in Tutum - you might want to"
                    " give an API role to this service for automatic backend reconfiguration" % (__version__, pid))
    else:
        logger.info("Tutum-haproxy %s (PID: %s) is not running in Tutum" % (__version__, pid))

    if Haproxy.cls_container_uri and Haproxy.cls_service_uri and Haproxy.cls_tutum_auth:
        def _websocket_open():
            Haproxy.cls_linked_container_object_cache.clear()
            run_haproxy("Websocket open")

        events = tutum.TutumEvents()
        events.on_open(_websocket_open)
        events.on_close(lambda: logger.info("Websocket close"))
        events.on_message(tutum_event_handler)
        events.run_forever()
    else:
        run_haproxy("Initial start")


if __name__ == "__main__":
    main()