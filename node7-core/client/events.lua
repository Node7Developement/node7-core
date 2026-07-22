RegisterCommand('n7notifytest', function()
    Node7Client.Notify('NODE7 notifications are working.', 'success', 4000)
end, false)

RegisterCommand('n7progresstest', function()
    Node7Client.Progress({ label = 'Testing progress bar...', duration = 5000, cancellable = true }, function(completed)
        Node7Client.Notify(completed and 'Progress completed.' or 'Progress cancelled.', completed and 'success' or 'warning')
    end)
end, false)
