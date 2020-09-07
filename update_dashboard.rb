 File.open "tekton-dashboard.yaml" do |f|
   DASHBOARD_VERSION = "v0.9.0"
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
