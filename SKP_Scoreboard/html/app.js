SKP_Scoreboard = {};

$(document).ready(function () {
  window.addEventListener("message", function (event) {
    switch (event.data.action) {
      case "open":
        SKP_Scoreboard.Open(event.data);
        break;
      case "close":
        SKP_Scoreboard.Close();
        break;
    }
  });
});

SKP_Scoreboard.Open = function (data) {
  $(".scoreboard").fadeIn(150).css('display', 'flex');
  $("#players").html(data.players);
  $("#lspd").html(data.cops);
  $("#ems").html(data.ems);
  $("#mech").html(data.mech);
  if (data.cops >= 1) {
    $("#lspd").html('<span style="color:#00ff00">'+data.cops+'</span>');
  }
  if (data.ems >= 1) {
    $("#ems").html('<span style="color:#00ff00">'+data.ems+'</span>');
  }
  if (data.mech >= 1) {
    $("#mech").html('<span style="color:#00ff00">'+data.mech+'</span>');
  }
};

SKP_Scoreboard.Close = function () {
  $(".scoreboard").fadeOut(150);
};
