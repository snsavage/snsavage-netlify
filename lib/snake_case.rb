module SnakeCase
  def snake_case(string)
    string.downcase.sub(/\W/, "_")
  end
end
