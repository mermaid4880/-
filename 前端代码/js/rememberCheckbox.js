    /*
        记忆复选框
    */
    var isChecked=true;
    function f_onCheckAllRow(checked)
    {
        for (var rowid in this.records)
        {
            if(checked)
                addCheckedCustomer(this.records[rowid]['taskDesc']);
            else
                removeCheckedCustomer(this.records[rowid]['taskDesc']);
        }
    }

    /*
    该例子实现 表单分页多选
    即利用onCheckRow将选中的行记忆下来，并利用isChecked将记忆下来的行初始化选中
    */
    var checkedCustomer = [];
    function findCheckedCustomer(taskDesc)
    {
        for(var i =0;i<checkedCustomer.length;i++)
        {
            if(checkedCustomer[i] == taskDesc && isChecked) return i;
        }
        return -1;
    }
    function addCheckedCustomer(taskDesc)
    {
        if(findCheckedCustomer(taskDesc) == -1)
            checkedCustomer.push(taskDesc);
    }
    function removeCheckedCustomer(taskDesc)
    {
        var i = findCheckedCustomer(taskDesc);
        if(i==-1) return;
        checkedCustomer.splice(i,1);
    }
    function f_isChecked(rowdata)
    {
        if (findCheckedCustomer(rowdata.taskDesc) == -1)
            return false;
        return true;
    }
    function f_onCheckRow(checked, data)
    {
        if (checked) addCheckedCustomer(data.taskDesc);
        else removeCheckedCustomer(data.taskDesc);
    }
    function f_getChecked()
    {
        alert(checkedCustomer.join(','));
    }
