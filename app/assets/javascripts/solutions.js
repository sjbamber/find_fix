// Submit solution form by taking data from nicedit form and adding it to the textarea
$(document).ready(function() {
    $('#solution_submit').click(function() {
        var data = $('#new_solution').find('.nicEdit-main').html();
        $('#rich_textarea').html(data);
    });
});