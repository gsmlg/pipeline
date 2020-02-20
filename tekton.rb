#!/usr/bin/env ruby

#require 'file'

File.open "release.yaml" do |f|
  cnt = File.read f
  #$stdout.print cnt

  reg = /gcr.io[\/A-Za-z0-9.:@-]+/
  out = cnt.scan reg

  newCnt = cnt

  out.each do |url|
    puts url
    newUrl = url.sub(/gcr.io\/tekton-releases\/github.com\/tektoncd\/pipeline.*\/cmd\//, 'docker.io/gsmlg/tekton-pipeline-').sub(/@.+$/, '')
    newCnt.gsub!(url, newUrl)
    puts newUrl
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end
  
  File.write 'updated.yaml', newCnt
end

