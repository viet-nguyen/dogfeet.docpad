---
layout: default
---

#generate for meta[name=description]
if !@document.description
  desc = @content.trim()
  desc = desc.substring 0, desc.indexOf '\n'
  #strip html tag
  desc = desc.replace(/(<([^>]+)>)/ig,'')
  @document.description = desc

#generate for meta[name=keywords]
if !@document.keywords and @document.tags
  @document.keywords = @document.tags.join ','

script src: 'http://platform.twitter.com/widgets.js'
script ->
  """
  //facebook
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  //google plusone
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();

  """
article "#post .post .#{@document.class}", typeof: 'sioc:post', about: "#{@document.url}", lang: 'ko-kr', ->
  header ->
    h1 property: 'dcterms:title', "#{@document.title}"

  footer '.modern-font .small-font', ->
    text @layout 'article-footer', @document

    style rel: 'stylesheet', media: 'screen, projection', scoped: 'scoped', ->
      """
      #social-buttons {
        margin-left: 30px;
      }
      """
    div '#social-buttons.pull-right', ->
      ul '.unstyled', ->
        articleUrl = "#{@site.url}#{@document.url}"
        twitters = @authors.toTwitter @document.author
        twitters = twitters.substr(1)

        li -> 
          a '.twitter-share-button', href: 'https://twitter.com/share'
          , 'data-url': articleUrl, 'data-via': twitters, 'data-count': 'horizontal', 'data-lang': 'en', 'Tweet'
        li -> div '.g-plusone', 'data-size': 'medium', 'data-href': articleUrl
        li -> div '.fb-like', 'data-href': articleUrl, 'data-send': 'false', 'data-layout': 'button_count', 'data-show-faces': 'false'

  div property: 'sioc:content', -> "#{@content}"

if @document.relatedDocuments.length > 0
	section '#related', ->
		h3 'Related Posts'
		div '.alert alert-info', ->
			ul ->
				for document in @document.relatedDocuments
					li ->
						span "#{document.date.toShortDateString()}"
						text '&raquo;'
						a href: "#{document.url}", "#{document.title}"

section '#comments', ->
  h3 'Feedback'

  div '.row', -> 
    text """
<div id="disqus_thread" class="well span10 offset1"></div>
<script type="text/javascript">
    var disqus_shortname = '#{@site.disqusShortName}';
    var disqus_identifier = '#{@document.url}';
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    """
	
	text """
    <div class="well span10 offset1">
      <div class="fb-like" data-href="#{@site.url}#{@document.url}" data-send="true" data-width="450" data-show-faces="true"></div>
	    <div class="fb-comments" data-href="#{@site.url}#{@document.url}" data-num-posts="1"></div>
	  </div>
	"""
