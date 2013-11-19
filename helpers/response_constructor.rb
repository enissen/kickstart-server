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
		update_hash["selenium-server"] = config["selenium-server-src"]
		
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


	#
	#
	def node_selenium_config(node, ip)
		nodes, services = lib('nodes'), lib('services')
		config = File.open(File.join("lib", "node_config.yml"), 'r') { |f| f.read }

		puts create_node_capabilities(nodes[node])

		{	"NODE_CAPABILITIES" => create_node_capabilities(nodes[node]), 
			"HOST_IP" => ip.strip,
			"HOST_PORT" => nodes[node]["selenium-port"],
			"HUB_IP" => services["selenium-hub-ip"],
			"HUB_PORT" => services["selenium-hub-port"]

		}.each { |key, value| config = config.gsub!(/#{key}/, "#{value}") }
	end


	#####################################################


	def create_node_capabilities(node)
		nodes = lib('nodes')
		cap = []

		nodes[node]['driver'].each do |key, values|
			cap << {"browserName" => "#{key}", "platform" => "#{nodes[node]['platform'].upcase}", 
					"version" => "#{values['version']}", "maxInstances" => values['instances'].to_i}.to_json
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
end
