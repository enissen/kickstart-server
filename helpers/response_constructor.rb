require "yaml"
require "json"

module ResponseConstructor

	# Checks if requested node is listed to node library.
	# Returns update hash if true.
	#
	# @params node [String] the name of the node
	#
	def update(node)
		nodes = lib('nodes')
		nodes[node].nil? ? {status: "Not listed"} : eval_update_hash(nodes[node])
	end


	# evaluates update hash for the specific node in form of [name: resource_path]
	# 
	# @params node [String] the name of the node
	#
	def eval_update_hash(node)
		config = lib('requirements')
		
		update_hash = {status: "Ok"}
		update_hash["selenium-server.jar"] = config["selenium-server-src"]
		update_hash["IEDriverServer.exe"] = config["ie-driver-server-#{node['bit']}-src"] if has_driver(node, "internet explorer")
		
		update_hash
	end


	# returns the basic node configuration of the requested
	# node (ready to paste)
	# 
	# @params node [String] the name of the node
	#
	def node_basic_config(node)
		config, service = lib('requirements'), lib('services')
		{'name' => node, 'selenium-version' => config["selenium-version"], 'kickstart' => service["kickstart-server"]}
	end


	# opens the default node config pattern and replaces
	# all node specific information
	#
	# @params node [String] the name of the node
	# @params ip [String] the ip address of the node
	#
	def node_selenium_config(node, ip)
		nodes, services = lib('nodes'), lib('services')
		config = File.open(File.join("lib", "node_config.yml"), 'r') { |f| f.read }

		{	node_capabilities: create_node_capabilities(nodes[node]), 
			remote_proxy: "\"#{services["selenium-remote-proxy"]}\"",
			host_ip: ip.strip,
			host_port: nodes[node]["selenium-port"],
			hub_ip: services["selenium-hub-ip"],
			hub_port: services["selenium-hub-port"]

		}.each { |key, value| config = config.gsub!(/#{key.to_s.upcase}/, "#{value}") }

		#config.gsub!(/(\n|\t|\s)/,'').to_json
		config.gsub!(/(\n|\t)/,'').to_json
	end


	##########################################################################


	# creates the node capability for each listed driver
	#
	# @params node [Hash] the hash representation of the node
	# @params caps [Hash] new hash to save created capabilitites
	#
	def create_node_capabilities(node, caps = [])

		node['driver'].each do |key, values|
			entry = { browserName: key, platform: node['platform'].upcase }
			values.each { |name, value| entry[name.to_s] = value }
			caps << entry
		end 

		caps.to_json  
	end


	# returns the content of the requested yaml file
	# 
	# @params name [String] the name of the yaml file without extension
	#
	def lib(name)
		lib = YAML::load(File.open(File.join("lib", "#{name}.yml")))
	end


	# returns true if given node supports the requested browser
	#
	# @params node [Hash] the hash representation of the node
	# @params browser [String] the broser name
	#
	def has_driver(node, browser)
		node['driver'].each do |key, value|
			return true if key.eql? browser
		end
		false
	end
end
