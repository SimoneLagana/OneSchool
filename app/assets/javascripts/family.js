
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
            <input type="hidden" id="CF" name="CF" value=${CF}>
            <label for="email">Email:</label>
            <br>
            <input type="email" id="email" name="email" disabled value=${email}>
            <br>
            <label for="old_password">Inserisci vecchia password:</label>
            <br>
            <input type="password" id="old_password" name="old_password" required>
            <br>
            <label for="password">Inserisci nuova password:</label>
            <br>
            <input type="password" id="password" name="password" required>
            <br>
            <br>
            <input type="submit" class ="submitBtn" value="Submit">
          </form>
      </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupcontainer.innerHTML = "";
    });
}