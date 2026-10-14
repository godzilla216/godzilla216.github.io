function btn_click_EditCopySlotD() {
	var str = s_str("msg_CopyUniforms");
	str = string_replace(str, "$num", 4);
	s_create_message("", str, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_copy_uniforms_slot_d, global.c_background, 1);
}

