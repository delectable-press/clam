<?php
/*
Plugin Name:  Smart wp-cron localhost for Docker
Plugin URI:   https://www.withinboredom.info
Description:  Uses the correct urls for docker
Version:      0.0.1
Author:       Robert Landers
Author URI:   https://www.withinboredom.info
License:      MIT License
*/

add_filter('cron_request', function($request) {
    if (!array_key_exists('args', $request)) {
        $request['args'] = [];
    }
    if (!array_key_exists('headers', $request['args'])) {
        $request['args']['headers'] = [];
    }
    $request['args']['headers']['host'] = preg_replace("(^https?://)","",site_url());
    $request['args']['headers']['user-agent'] = 'CRONUSERAGENT';
    $request['args']['timeout'] = 0.5;
    $target = site_url();
    $port = $_SERVER['SERVER_PORT'];
    $request['url'] = str_ireplace($target, "http://127.0.0.1:$port", $request['url']);
    return $request;
});