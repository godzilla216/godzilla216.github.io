function btn_click_EditCopySlotC() {
	var str = s_str("msg_CopyUniforms");
	str = string_replace(str, "$num", 3);
	s_create_message("", str, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_copy_uniforms_slot_c, global.c_background, 1);
}

