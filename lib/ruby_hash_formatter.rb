# generate indented ruby 1.9 hash syntax
def pretty_ruby_hash(ruby_hash)
  hash_key_regex = /\"([a-zA-Z0-9_-]+)\":/
  JSON.pretty_generate(ruby_hash).gsub(hash_key_regex, '\1:')
end
