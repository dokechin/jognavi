var Equipment = Backbone.Model.extend({
  defaults:{
  name: "",
  user_id: "",
  url: "",
  img: "",
  price: 0,
  store_url: "",
  store_name: "",
  bought_at : "2013-01-01",
  polish_at : "2013-01-01",
  distance : 0
  }
});
