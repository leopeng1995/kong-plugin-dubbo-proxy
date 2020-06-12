package = "kong-plugin-dubbo-proxy"

version = "0.1.0-1"

supported_platforms = {"linux", "macosx"}

source = {
  url = "https://github.com/leopeng1995/kong-plugin-dubbo-proxy.git",
  branch = "master"
}

description = {
  summary = "Kong plugin for Dubbo Proxy",
  homepage = "https://github.com/leopeng1995/kong-plugin-dubbo-proxy",
  license = "MIT"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.dubbo-proxy.schema"] = "kong/plugins/dubbo-proxy/schema.lua",
    ["kong.plugins.dubbo-proxy.handler"] = "kong/plugins/dubbo-proxy/handler.lua",
  }
}
