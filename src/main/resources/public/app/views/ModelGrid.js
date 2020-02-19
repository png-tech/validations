Ext.define('app.views.ModelGrid', {
    extend: 'Ext.grid.Panel',
    requires: [
        'app.custom.NoTotalPagesPagingToolbar',
        'app.views.filters.filter.MultiString',
        'app.controllers.ModelGridController'
    ],

    enableColumnHide: false,

    plugins: 'gridfilters',

    viewConfig: {
        getRowClass: function (record) {
            if (record.get('deactivated') === true)
                return 'red-row'
        }
    },

    constructor: function () {
        this.callParent(arguments);

        var store = this.createStore({
            pageSize: 200 //записей на одной странице.
        });
        this.reconfigure(store);
        this.down('custom-pagingtoolbar').bindStore(store);
    },

    /** @protected */
    createStore: function (storeConfig) {
        throw 'should be overridden';
    },


    listeners: {
        selectionChange: 'onSelectionChange',
        itemdblclick: 'edit',
        show: 'onShow'
    },

    dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        margin: 0,
        padding: 0,
        items: [
            {
                xtype: 'panel',
                margin: 0,
                padding: 0,
                items: [
                    {
                        xtype: 'button',
                        name: 'create',
                        scale: 'large',
                        text: 'Создать',
                        listeners: {
                            click: 'create'
                        }
                    },
                    {
                        xtype: 'button',
                        name: 'edit',
                        scale: 'large',
                        disabled: true,
                        text: 'Редактировать',
                        listeners: {
                            click: 'edit'
                        }
                    },
                    {
                        xtype: 'button',
                        name: 'merge',
                        scale: 'large',
                        text: 'Объединить теги',
                        hidden: true,
                        disabled: true,
                        listeners: {
                            click: 'merge'
                        }
                    }
                ]
            },
            {
                xtype: 'panel',
                border: false,
                items: [
                    {
                        xtype: 'custom-pagingtoolbar',
                        border: 0
                    }
                ]
            }
        ]
    }],


    getEditButton: function () {
        return this.down('button[name=edit]');
    },

    getMergeButton: function () {
        return this.down('button[name=merge]');
    }

});