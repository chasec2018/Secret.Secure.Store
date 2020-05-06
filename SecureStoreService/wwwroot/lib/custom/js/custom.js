
function CopyToClipBoard(id) {

    const CopyText = document.getElementById(id).innerText;
    const NewElement = document.createElement('textarea');
    NewElement.value = CopyText;

    NewElement.setAttribute('readonly', '');
    NewElement.style.position = 'absolute';
    NewElement.style.left = '-9999px';

    document.body.appendChild(NewElement);
    NewElement.select();
    document.execCommand('copy');
    document.body.removeChild(NewElement);

    var prefix = "RTXT-";
    var prefixid = prefix.concat(id)

    var tooltip = document.getElementById(prefixid);
    tooltip.innerHTML = "Copied";

}

function ToolTipHover(id) {
    var tooltip = document.getElementById(RTXT -id);
    tooltip.innerHTML = "Copy to clipboard";
}

