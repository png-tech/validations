Ext.define('app.views.TagWindow', {
    extend: 'app.views.ModelWindow',
    requires: [
        'app.controllers.TagWindowController'
    ],

    controller: 'tag-window-controller',

    /** @override */
    getFormItems: function () {
        return [
            {
                xtype: 'textfield',
                name: 'id',
                hidden: true
            },
            {
                xtype: 'textfield',
                fieldLabel: 'Наименование',
                name: 'name'
            },
            {
                xtype: 'resizable-textarea',
                fieldLabel: 'Описание',
                name: 'description'
            },
            {
                xtype: 'resizable-textarea',
                fieldLabel: 'Комментарий',
                name: 'commentary'
            },
            {
                xtype: 'numberfield',
                name: 'version',
                hidden: true
            },
            {
                xtype: 'checkbox',
                inputValue: true,
                uncheckedValue: false,
                name: 'deactivated',
                hidden: true
            }
        ];
    }

});
