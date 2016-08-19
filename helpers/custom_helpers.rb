module CustomHelpers
  def full_url(path)
    if development?
      "http://#{config[:server_name]}:#{config[:port]}/#{path}"
    end
  end
end
