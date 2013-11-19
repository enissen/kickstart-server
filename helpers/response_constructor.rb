require "yaml"

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
		{name: node, selenium-version: config["selenium-version"], kickstart: service["kickstart-server"]}
	end


	#####################################################


	# returns the content of the requested yaml file
	# 
	# @params name [String] the name of the yaml file without extension
	#
	def lib(name)
		lib = YAML::load(File.open(File.join("lib", "#{name}.yml")))
	end
end
