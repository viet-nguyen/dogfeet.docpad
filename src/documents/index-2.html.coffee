--- 
layout: 'default'
date: '2009-05-21T16:06:05.000Z'
---
articleStartCount = 4
articlePerPage = 4
articleTotalCount = 0
for document in @documents
  if 0 is document.url.indexOf '/articles'
	articleTotalCount++

articleCount = 0
for document in @documents
  if 0 is document.url.indexOf '/articles'
    articleCount++
    if (articleStartCount < articleCount) and (articleCount <= articleStartCount+articlePerPage)
      article '.post', ->
        header ->
          a href: document.url, ->
            h1 document.title

        footer ->
          span ->
            text 'by '
            @authors.render document.author
          text ' | '
          span property: 'dc:created', "#{document.date.toShortDateString()}"
          text ' | '
          tagsRendered = []
          for tag in document.tags
            tagsRendered.push """<a href="/site/tagmap.html##{tag.toLowerCase()}">#{tag}</a>"""
          span tagsRendered.join ', '
          text ' | '
          span """<a href="#{document.url}#disqus_thread" data-disqus-identifier="#{document.url}"></a>"""

        if document.firstRendered is undefined
          text @tool.summary document.contentRendered
        else
          text @tool.summary document.firstRendered

        p -> a '.btn', href: document.url, 'View Detail &raquo;'

div ->
  h2 'Pagination'
  ul ->
  for num in [0..(articleTotalCount/articlePerPage)]
	if num is 0
		li -> a href: "/", "#{num+1}"
	if num isnt 0
		li -> a href: "/index-#{num+1}.html", "#{num+1}"