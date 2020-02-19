Ext.define('app.controllers.ModelGridController', {
    extend: 'Ext.app.ViewController',

    onSelectionChange: function (model, selected) {
        if (selected.length > 0) {
            this.getView().getEditButton().setDisabled(false);
        }
    },

    create: function () {
        var window = this.createWindow({
            operation: 'create',
            gridStore: this.getView().store
        });
        window.show();
    },

    edit: function () {
        var row = this.getView().getSelectionModel().getSelection()[0];

        var window = this.createWindow({
            operation: 'edit',
            gridStore: this.getView().store
        });
        window.show();
        if (row.get('deactivated') === true) {
            window.setReadOnly();
        }
        window.setLoading(true);

        var requestConfig = {
            scope: this,
            success: function (record) {
                window.down('form').loadRecord(record);
            },
            callback: function () {
                window.setLoading(false);
            }
        };


        this.loadModel(row.get('id'), requestConfig, window);
    },

    createWindow: function (config) {
        throw 'should be overridden';
    },

    loadModel: function (id, requestConfig) {
        throw 'should be overridden';
    },

    onShow: function() {
        this.getView().getMergeButton().setHidden(true);
    }

});