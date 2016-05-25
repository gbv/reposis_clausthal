(function($){
    $.fn.fixedMenu=function(){
        return this.each(function(){
            var menu= $(this);
            menu.find('a').bind('click',function(){
              if ($(this).parent().hasClass('active_login')){
                  $(this).parent().removeClass('active_login');
              }
              else{
                  $(this).parent().parent().find('.active_login').removeClass('active_login');
                  $(this).parent().addClass('active_login');
              }
            });
        });
    }
})(jQuery);

$﻿(document).ready(function(){
  $('#button_search_simple').click(function() {
    if ($('#search_block_simple').css('display') == 'none')
    {
      $('#search_block_simple').show();
      $('#search_block_complex').hide();
    }
    else
    {
      $('#search_block_simple').hide();
    }
  });
  $('#button_search_complex').click(function() {
    if ($('#search_block_complex').css('display') == 'none')
    {
      $('#search_block_simple').hide();
      $('#search_block_complex').show();
    }
    else
    {
      $('#search_block_complex').hide();
    }
  });

  $('.button_options').click(function() {
    showOptions($(this).next('.options'));
  });

  block_names = new Array("title","abstract","category","institution","derivate","system");
  $.each( block_names, function(index, value) {
    $('#'+value+'_switch').click(function() {
      if ($('#'+value+'_content').css('display') == 'none')
      {
        $('#'+value+'_content').show();
        $('#'+value+'_switch').addClass('open');
      }
      else
      {
        $('#'+value+'_content').hide();
        $('#'+value+'_switch').removeClass('open');
      }
    })
  });

  $('#toDerivateDetails').click(function() {
      $('#derivate_content').show();
      $('#derivate_switch').addClass('open');
  });

  $('#confirm_deletion').click(function(d){
    d.preventDefault();
    jConfirm('Wollen Sie dieses Dokument wirklich löschen?', 'Löschen bestätigen', function(r) {
      if (r) location.href = $('#confirm_deletion').attr('href');
    });
  });

  $('.confirm_derivate_deletion').click(function(d){
    d.preventDefault();
    var url = $(this).attr('href');
    jConfirm('Wollen Sie dieses Datenobjekt wirklich löschen?', 'Löschen bestätigen', function(r) {
      if (r) location.href = url;
    });
  });

  $('#button_login').fixedMenu();

  $('#index_search, #nav_search').focus(function() {
    if (this.value=='Suchbegriff')
    {
      this.value = '';
    }
    if ($(this).hasClass('search_text_gray'))
    {
      $(this).removeClass('search_text_gray');
    }
  });

  $('#index_search, #nav_search').blur(function() {
    if (this.value=='')
    {
      this.value = 'Suchbegriff';
      $(this).addClass('search_text_gray');
    }
  });

  $("#index_search_form").submit(function () {
       $('input[class="search_text_gray"]').val("*");
  });

  $("#person_index #index_search_form").submit(function () {
      $('#index_search').val($('#index_search').val()+".*");
  });

  $('span.madress').each(function(i) {
      var text = $(this).text();
      var address = text.replace(" [at] ", "@");
      $(this).after('<a href="mailto:'+address+'">'+ address +'</a>')
      $(this).remove();
  });

  $('#zdb_form').submit(function() {
      var inputValue = $("input[name='zdbid']").val();
      $("input[name='zdbid']").val($.trim(inputValue));
  });

}); // close document.ready(function)

function showOptions(element)
{
  if (element.css('display') == 'none')
  {
    $('#detail_view .options').hide();
    $('.derivate_options').css('z-index',1000);
    element.show();
    element.parent('.derivate_options').css('z-index',2000);
  }
  else
  {
    element.hide();
    element.parent('.derivate_options').css('z-index',1000);
  }
}
