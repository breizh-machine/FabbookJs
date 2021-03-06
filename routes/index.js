// Generated by CoffeeScript 1.4.0
(function() {
  var db;

  db = require("../db");

  exports.hello = function(req, res) {
    var name;
    name = req.params.name;
    return res.render("hello", {
      name: name,
      title: name
    });
  };

  exports.news = function(req, res) {
    return db.Article.findAll().success(function(articles) {
      return res.render("articles", {
        articles: articles,
        title: 'blog'
      });
    });
  };

  exports.show = function(req, res) {
    var id;
    id = parseInt(req.params.id);
    return db.Article.find(id).success(function(article) {
      if (article) {
        return res.render("article", {
          article: article,
          title: article.title
        });
      } else {
        return res.send(404, "Sorry, we cannot find that!");
      }
    });
  };

}).call(this);
