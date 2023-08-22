document.addEventListener("DOMContentLoaded", function() {
    const executeMethodButton = document.getElementById("execute-method-button");
  
    executeMethodButton.addEventListener("click", function() {
      // Invia una richiesta AJAX al server per eseguire il metodo del controller
      fetch("/controller_name/metodo_da_eseguire", {
        method: "POST", // O "GET" a seconda del metodo del controller
        headers: {
          "X-CSRF-Token": Rails.csrfToken(), // Aggiungi il token CSRF per Rails
          "Content-Type": "application/json",
        },
        body: JSON.stringify({}), // Puoi passare dati se necessario
      })
      .then(response => response.json())
      .then(data => {
        // Puoi fare qualcosa con la risposta dal server (se necessario)
      })
      .catch(error => {
        console.error("Errore nella richiesta AJAX:", error);
      });
    });
  });