local typedefs = require "kong.db.schema.typedefs"

local schema = {
  name = 'dubbo-proxy',
  fields = {
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { application_name = { type = "string", required = true } },
          { interface_name = { type = "string", required = true } },
          { version = { type = "string", required = false } },
          { group = { type = "string", required = false } },
          { method_name = { type = "string", required = true } },
          { param_types = { type = "array", elements = { type = "string" } } },
        },
        entity_checks = {
        },
      },
    },
  },
}

-- run_on_first typedef/field was removed in Kong 2.x
-- try to insert it, but simply ignore if it fails
pcall(function()
        table.insert(schema.fields, { run_on = typedefs.run_on_first })
      end)

return schema
