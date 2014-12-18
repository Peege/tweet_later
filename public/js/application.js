$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  function check_job_status(job_id)
    {
      var request = $.ajax(
      {
        type: "GET",
        url: '/status/' + job_id
      });
      request.done(function(response)
      {
        if (response === 'true')
        {
          $('#status').html('Done');
          $('#tweet_loader').hide();
        }
        else
        {
          setTimeout(function(){ check_job_status(job_id) }, 1000);
        }
      });
    };

  $("#post_later").submit(function(event)
  {
    // console.log("test2")
    // $('#status').show();
    // $("#tweet_loader").show();
    var postData = $(this).serializeArray();
    var url = $(this).attr('action');
    $.ajax(
    {
      url : url,
      type: "POST",
      data : postData,
      success:function(result)
      {
        $("#status").html('Tweeting...');
        $('#tweet_loader').html("<center><img src='/images/ajax-loader.gif'></center>");
        setTimeout(function(){ check_job_status(result) }, 1000);
        document.getElementById("post_later").reset();
        populate_tweets();
      },
      error: function(jqXHR, textStatus, errorThrown)
      {
        $("#status").html('Tweet Failed');
      }
    });
    event.preventDefault(); //STOP default action
  });


});

