
class CollectCode
  def collect(data, start, len, flg = true)
    return data[start] if len == 1
    begin
      buf = data[start..start + len]
      buf.reverse! if flg == false
      text = ''
      buf.each { |e| text += e.to_s(16).rjust(2, '0') }
      return text.to_i(16)
    end
    false
  end
end
