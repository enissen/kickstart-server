require "yaml"

module ResponseConstructor

	def update(node)
		nodes = YAML::load(File.open(File.join('lib', 'nodes.yml')))
		nodes[node].nil? ? {status: "Not listed"} : eval_update_hash(nodes[node])
	end

	def eval_update_hash(node)
		config = YAML::load(File.open(File.join('lib', 'requirements.yml')))
		
		update_hash = {status: "Ok"}
		update_hash["selenium-server"] = config["selenium-server-src"]
		
		update_hash
	end
end
