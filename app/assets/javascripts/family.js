
function popup(news) {
    popupcontainer = document.getElementById("popup");
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