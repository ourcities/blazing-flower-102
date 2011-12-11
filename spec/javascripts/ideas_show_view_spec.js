describe("IdeasShowView", function(){
  var view = null;
  MR.router = {bind: function(){}};

  beforeEach(function(){
    var body = $('body').append('<div id="member_panel">');
    view = new MR.IdeasShowView({el: body});
    spyOn($, "facebox");
  });

  describe("#bindRoutes", function(){
    it("should bind fork route", function(){
      spyOn(MR.router, "bind");
      view.bindRoutes();
      expect(MR.router.bind).toHaveBeenCalledWith('route:fork', view.fork);
    });
  });

  describe("#fork", function(){
    it("should call facebox with div #confirm_fork_idea if user is logged in", function(){
      spyOn(view, "isLoggedIn").andReturn(true);
      view.fork();
      expect($.facebox).toHaveBeenCalledWith({div: '#confirm_fork_idea'});
    });

    it("should call facebox with login if user is anonymous", function(){
      spyOn(view, "isLoggedIn").andReturn(false);
      spyOn(view, "loginDialog");
      view.fork();
      expect(view.loginDialog).toHaveBeenCalled();
    });
  });

});
