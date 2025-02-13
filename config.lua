Config = {
  Debug = true,
  AllowOnlyPlates = false, -- Set to true to allow only specific plates
  AllowedPlates = { "ABC", "XYZ789" }, -- List of allowed plates
  AllowOnlyModels = true, -- Set to true to allow only specific vehicle models
  AllowedModels = { "jb700", "sheriff" }, -- List of allowed vehicle models
  AllowedModelHashes = {}, -- Table to store hash keys of allowed vehicle models
  SpikeDeletionInterval = 15000 -- Time in milliseconds before spikes are deleted (e.g., 15000ms = 15 seconds)
}

-- Populate AllowedModelHashes with hash keys of allowed vehicle models
for _, model in pairs(Config.AllowedModels) do
  Config.AllowedModelHashes[GetHashKey(model)] = true
end