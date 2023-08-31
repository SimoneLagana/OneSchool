function editpassword(CF, email) {
    popupcontainer = document.getElementById("popupcontainer");
  
    popupcontainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">&times;</div>
          <form action="/student/changepassword" method="post">
            <input type="text" id="CF" name="CF" hidden value=${CF}>
            <label for="email">Email</label>
            <input type="email" id="email" name="email" disabled value=${email}><br>

            <label for="old_password">Inserisci vecchia password</label>
            <input type="password" id="old_password" name="old_password" required><br>
            <label for="password">Inserisci nuova password</label>
            <input type="password" id="password" name="password" required><br>
            <input type="submit" value="Submit">
          </form>
      </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupcontainer.innerHTML = "";
    });
}