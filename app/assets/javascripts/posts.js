$(document).ready(function() {
    $('#post_submit').click(function() {
        var data = $('#new_post').find('.nicEdit-main').html().text();
        $('#rich_textarea').html(data);
    });
});