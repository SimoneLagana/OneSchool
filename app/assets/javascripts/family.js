
function popup(news) {
    popupcontainer = document.getElementById("popup");
    console.log(news);
    popupcontainer.innerHTML = `
    <div class="popupMenu">
    <div id="closePopup">&times;</div>
        ${news}
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupcontainer.innerHTML = "";
    });
}


function editpassword(CF, email) {
    popupcontainer = document.getElementById("popupcontainer");
  
    popupcontainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">&times;</div>
          <form action="/family/changepassword" method="post">
            <input type="text" id="CF" name="CF" value=${CF}>
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