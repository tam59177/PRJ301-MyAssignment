/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
function pagger(id,pageindex,totalpage,gap)
{
    var container = document.getElementById(id);
    var content = '';
    
    if(pageindex>gap + 1)
            content += '<a href="list?page=1">First</a>';
    
    if(pageindex-gap>2)
            content += '<span>...</span>';
    
    for (var i=pageindex-gap;i<pageindex;i++)
    {
        if(i>0)
            content += '<a href="list?page='+i+'">'+i+'</a>';
    }
    
    content += '<span>'+pageindex+'</span>';
    
    for (var i=pageindex+1;i<=pageindex+gap;i++)
    {
        if(i<=totalpage)
            content += '<a href="list?page='+i+'">'+i+'</a>';
    }
    
    if(pageindex+gap<=totalpage - 2)
            content += '<span>...</span>';
        
    if(pageindex<totalpage - gap)
            content += '<a href="list?page='+totalpage+'">Last</a>';
    
    container.innerHTML = content;
    
}

