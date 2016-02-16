docker-machine rm -f manager
sleep 1
docker-machine rm -f generator
sleep 1

# Generate a token for swarm
docker-machine create -d virtualbox --virtualbox-memory=768 generator
docker-machine env generator | invoke-expression
docker run -d -p "8000:8000" --restart=always boomtownroi/consul-ui

# Create the machines
docker-machine create -d virtualbox --virtualbox-memory=1024 --virtualbox-cpu-count=2 --swarm --swarm-master --swarm-discovery "consul://$(docker-machine ip generator):8000" --engine-opt="cluster-store=consul://$(docker-machine ip generator):8000" --engine-opt="cluster-advertise=eth1:2376" manager
# docker-machine create -d virtualbox --virtualbox-memory=1024 --virtualbox-cpu-count=2 --swarm --swarm-discovery "consul://$(docker-machine ip generator):8000" --engine-opt="cluster-store=consul://$(docker-machine ip generator):8000" --engine-opt="cluster-advertise=eth1:2376" agent1
docker-machine env --swarm manager | invoke-expression