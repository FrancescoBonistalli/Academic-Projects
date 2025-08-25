module it.unipi.HealthManagerClient {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.base;
    requires com.google.gson;
    requires java.sql;

    opens it.unipi.HealthManagerClient to javafx.fxml, com.google.gson;
    exports it.unipi.HealthManagerClient;
}
