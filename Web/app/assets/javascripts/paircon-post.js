function initializePostForm() {
    $('#new_post').validate({
        rules: {
            'post[description]': {
                required: true
            }
        }
    });
}