
#= 
  read markdown files  make dynamical list
=#

using DataFrames,CSV
using Markdown
path="/Users/lunarcheung/Desktop/readme/docs/content"
strs=[]
for (root, dirs, files) in walkdir(path)
    for file in files
        name,suffix = split(file, ".")
        if suffix == "md"
            res = """* [$name](./content/$(name).md)"""
            push!(strs, res)
           
        else
            continue
        end
    end
end
# file = open("./test.md", "a") 
# write(file,strs)
# close(file)

function read_files(files)
    for file in files
        name,suffix = split(file, ".")
        if suffix == "md"
           @info "$(dir)/$(name)"
           
        else
            continue
        end
    end
end

function read_dir(dirs,files)
    for dir in dirs 
        for file in files
            name,suffix = split(file, ".")
            if suffix == "md"
               @info "$(dir)/$(name)"
               
            else
                continue
            end
        end
    end
end

for (root, dirs, files) in walkdir(path)
    !isempty(files)&&read_files(files)
    read_dir(dirs,files)
end
