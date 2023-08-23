
function editpassword(email) {
    popupcontainer = document.getElementById("popupcontainer");
  
    popupcontainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">&times;</div>
          <form action="/teacher/changepassword" method="post">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value=${email}>

            <label for="old_password">Inserisci vecchia password</label>
            <input type="password" id="old_password" name="old_password" required>
            <label for="password">Inserisci nuova password</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Submit">
          </form>
      </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupcontainer.innerHTML = "";
    });
}