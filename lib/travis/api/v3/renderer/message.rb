module Travis::API::V3
  class Renderer::Message < ModelRenderer
    representation(:standard, :id, :level, :key, :code, :args, :src, :line)
  end
end
