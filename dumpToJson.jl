using EzXML

println(ARGS)

doc = root(readxml(ARGS[1]))
for node in findall("//node//tag[contains(@k, ':en')]", doc)
  println(node["name"])
end