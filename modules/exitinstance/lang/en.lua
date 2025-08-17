local strings = {
    HR_BINDING_EXIT_INSTANCE = "Exit Instance Immediately",
    HR_BINDING_SEND_EXIT_INSTANCE = "Eject Group",
}

for id, val in pairs(strings) do
    ZO_CreateStringId(id, val)
    SafeAddVersion(id, 1)
end