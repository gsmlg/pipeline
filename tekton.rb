#!/usr/bin/env ruby


File.open "tekton.yaml" do |f|
  cnt = File.read f

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
  
  File.write 'updated_tekton.yaml', newCnt
end

File.open "tekton-dashboard.yaml" do |f|
  DASHBOARD_VERSION = "v0.6.1"
  cnt = File.read f

  reg = /gcr.io[\/A-Za-z0-9.:@-]+/
  out = cnt.scan reg

  newCnt = cnt

  # gcr.io/tekton-releases/github.com/tektoncd/dashboard/cmd/dashboard
  out.each do |url|
    puts url
    newUrl = url.sub(/gcr.io\/tekton-releases\/github.com\/tektoncd\/dashboard.*\/cmd\//, 'docker.io/gsmlg/tekton-dashboard-').sub(/@.+$/, ":#{DASHBOARD_VERSION}")
    newCnt.gsub!(url, newUrl)
    puts newUrl
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end
  
  File.write 'updated_dashboard.yaml', newCnt
end


File.open "tekton-trigger.yaml" do |f|
  TRIGGER_VERSION = "v0.4.0"
  cnt = File.read f

  reg = /gcr.io[\/A-Za-z0-9.:@-]+/
  out = cnt.scan reg

  newCnt = cnt

  # gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/
  out.each do |url|
    puts url
    newUrl = url.sub(/gcr.io\/tekton-releases\/github.com\/tektoncd\/triggers\/cmd\//, 'docker.io/gsmlg/tekton-triggers-').sub(/@.+$/, ":#{TRIGGER_VERSION}")
    newCnt.gsub!(url, newUrl)
    puts newUrl
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end
  
  File.write 'updated_trigger.yaml', newCnt
end




