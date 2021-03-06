# Admin Controler to add new article

db = require("../db")
form = require("../form/article")

exports.listArticle = (req, res ) ->
  db.Article.findAll().success (articles) ->
    res.render "admin/listArticle",
      articles: articles
      title: 'blog'

exports.newArticle = (req, res ) ->
  res.render "admin/newArticle",
    form: form.ArticleForm.toHTML()
    title: 'admin'

exports.editArticle = (req, res ) ->
  id = parseInt(req.params.id)
  db.Article.find(id).success (blog) ->
    if blog
      formEdit = form.ArticleForm.bind(blog.values)
      res.render "admin/editArticle",
        form: formEdit.toHTML()
        title: "edit "+blog.title
    else
      res.send 404, "Sorry, we cannot find that!"

exports.updateArticle = (req, res ) ->
  form.ArticleForm.handle req,
    success: (form) ->
      id = parseInt(req.params.id)
      db.Article.find(
        id
        ).success (article) ->
          if article
            article.updateAttributes(
              form.data
            ).success () ->
              req.method = 'get'
              res.redirect '/admin/article/list'
          else
            res.send 404, "Sorry, we cannot find that!"
    other: (form) ->
      res.render "admin/editArticle",
        form: form.toHTML()
        title: 'failed'
        
exports.deleteArticle = (req, res ) ->
  id = parseInt(req.params.id)
  db.Article.find(id).success (blog) ->
    if blog
      blog.destroy().success ->
        req.method = 'get'
        res.redirect '/admin/article/list'
    else
      res.send 404, "Sorry, we cannot find that!"
 
exports.createArticle = (req, res ) ->
  form.ArticleForm.handle req,
    success: (form) ->
      db.Article.create(
        form.data
      ).success (article) ->
          req.method = 'get'
          res.redirect '/admin/article/list'
    other: (form) ->
      res.render "admin/newArticle",
        form: form.toHTML()
        title: 'failed'
