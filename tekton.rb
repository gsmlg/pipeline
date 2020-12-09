#!/usr/bin/env ruby


File.open "tekton.yaml" do |f|
  cnt = File.read f

  reg = /gcr.io[\/A-Za-z0-9.:@-]+/
  out = cnt.scan reg

  newCnt = cnt

  out.each do |url|
    puts url
    if /gcr.io\/distroless\/base/ =~ url
      newUrl = "docker.io/gsmlg/distroless-base"
    else
      newUrl = url.sub(/gcr.io\/tekton-releases\/github.com\/tektoncd\/pipeline.*\/cmd\//, 'docker.io/gsmlg/tekton-pipeline-').sub(/@.+$/, '')
    end
    puts newUrl
    newCnt.gsub!(url, newUrl)
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end

  regGcloud = /google\/cloud-sdk@sha256:[A-Za-z0-9]+/
  regt = /google\/cloud-sdk:([A-Za-z0-9-\.]+)/
  out2 = cnt.scan regGcloud

  out2.each do |url|
    p url
    m = regt.match newCnt
    tag = m[1]
    newUrl = "docker.io/gsmlg/google-cloud-sdk:#{tag}"
    p newUrl
    newCnt.gsub!(url, newUrl)
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end
  
  File.write 'updated_tekton.yaml', newCnt
end

File.open "tekton-dashboard.yaml" do |f|
  DASHBOARD_VERSION = "v0.11.1"
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
  cnt = File.read f

  reg = /gcr.io[\/A-Za-z0-9.:@-]+/
  out = cnt.scan reg

  newCnt = cnt

  # gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/
  out.each do |url|
    puts url
    newUrl = url.sub(/gcr.io\/tekton-releases\/github.com\/tektoncd\/triggers\/cmd\//, 'docker.io/gsmlg/tekton-triggers-').sub(/@.+$/, "")
    newCnt.gsub!(url, newUrl)
    puts newUrl
    puts `docker pull #{url}`
    puts `docker tag #{url} #{newUrl}`
    puts `docker push #{newUrl}`
    `echo #{newUrl} >> tekton-images.txt`
  end
  
  File.write 'updated_trigger.yaml', newCnt
end




