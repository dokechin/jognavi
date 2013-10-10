PaginatedView = Backbone.View.extend({
    events: {
      'click a.servernext': 'nextResultPage',
      'click a.serverprevious': 'previousResultPage',
      'click a.orderUpdate': 'updateSortBy',
      'click a.serverlast': 'gotoLast',
      'click a.page': 'gotoPage',
      'click a.serverfirst': 'gotoFirst',
      'click a.serverpage': 'gotoPage',
      'click .serverhowmany a': 'changeCount'
    },
    tagName: 'ul',
    className: 'pagination',
    template : _.template(
     '{{ if (currentPage > firstPage) { }}' +
        '<li><a href="#" class="serverprevious">&laquo;</a></li>' +
     '{{ }else{ }}'+
        '<li class="disabled"><span>&laquo;</span><li>' +
     '{{ } }}' +
     '{{ for(p=1;p<=totalPages;p++){ }}' +
       '{{ if (currentPage == p) { }}' +
         '<li class="active"><span class="page selected">{{= p }}</span><li>' +
       '{{ } else { }}' +
         '<li><a href="#" class="page">{{= p }}</a><li>' +
       '{{ } }}' +
     '{{ } }}' +
     '{{ if (lastPage != currentPage) { }}' +
       '<li><a href="#" class="servernext">&raquo;</a></li>' +
     '{{ }else{ }}'+
        '<li class="disabled"><span>&raquo;</span><li>' +
     '{{ } }}'),
    initialize: function () {


      this.collection.on('reset', this.render, this);
      this.collection.on('sync', this.render, this);

      this.$el.appendTo('#pagination');

    },

    render: function () {
      var html = this.template(this.collection.info());
      this.$el.html(html);
    },

    updateSortBy: function (e) {
      e.preventDefault();
      var currentSort = $('#sortByField').val();
      this.collection.updateOrder(currentSort);
    },

    nextResultPage: function (e) {
      e.preventDefault();
      this.collection.requestNextPage();
    },

    previousResultPage: function (e) {
      e.preventDefault();
      this.collection.requestPreviousPage();
    },

    gotoFirst: function (e) {
      e.preventDefault();
      this.collection.goTo(this.collection.information.firstPage);
    },

    gotoLast: function (e) {
      e.preventDefault();
      this.collection.goTo(this.collection.information.lastPage);
    },

    gotoPage: function (e) {
      e.preventDefault();
      var page = $(e.target).text();
      this.collection.goTo(page);
    },

    changeCount: function (e) {
      e.preventDefault();
      var per = $(e.target).text();
      this.collection.howManyPer(per);
    }

  });
