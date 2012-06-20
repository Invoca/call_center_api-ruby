module HTTPHelper
  # Using custom set_form_data and urlencode
  # Native NET/HTTP does not support duplicate parameter names

  def self.set_form_data(request, params, sep='&')
    request.body = params.map do |k,v| 
      if v.instance_of?(Array)
        v.map { |e| "#{urlencode(k.to_s)}[]=#{urlencode(e.to_s)}" }.join(sep)
      else
        "#{urlencode(k.to_s)}=#{urlencode(v.to_s)}"
      end
    end.join(sep)
    request.content_type = 'application/x-www-form-urlencoded'
  end

  def self.urlencode(str)
    str.gsub(/[^a-zA-Z0-9_\.\-]/n) {|s| sprintf('%%%02x', s[0]) }
  end
end