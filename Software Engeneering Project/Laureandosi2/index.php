<?php
// pagina base del tema
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><?php bloginfo('name'); ?></title>
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
    <p>Pagina predefinita</p>
    <?php wp_footer(); ?>
</body>
</html>
