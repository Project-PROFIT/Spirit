###
    A storage for form elements (inputs, text-areas, ets)
    It auto-clears on form submission. Also auto-sync across tabs.
###


class Storage

    constructor: (el, lsKey) ->
        @el = el
        @lsKey = lsKey
        @isUpdating = false
        @setUp()

    setUp: ->
        if @lsKey of localStorage
            @updateField()

        window.addEventListener('storage', @updateField)  # On change
        @el.addEventListener('input', @updateStorage)
        @el.addEventListener('change', @updateStorage)
        @el.addEventListener('propertychange', @updateStorage)
        @el.closest('form').addEventListener('submit', @clearStorage)

    _updateStorage: =>
        value = @el.value

        try
            # May trigger storage
            localStorage[@lsKey] = value
        catch err
            # The localStorage is probably full, nothing to do other than clearing it
            localStorage.clear()

        return

    updateStorage: =>
        @isUpdating = true
        try
            @_updateStorage()
        finally
            @isUpdating = false

        return

    updateField: =>
        if @isUpdating
            return

        @el.value = localStorage[@lsKey]
        return

    clearStorage: =>
        @isUpdating = true
        try
            # Triggers storage
            delete localStorage[@lsKey]
        finally
            @isUpdating = false

        return


stModules.store = (elm, lsKey) -> new Storage(elm, lsKey)
stModules.Storage = Storage
