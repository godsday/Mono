// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => '¡Hola, bienvenido!';

  @override
  String get total_balance => 'Balance total';

  @override
  String get currency_symbol => '€';

  @override
  String get onboarding_title => 'Gasta con inteligencia, ahorra más';

  @override
  String get onboarding_subtitle =>
      'Toma el control de tu dinero con potentes herramientas de seguimiento y planificación';

  @override
  String get enter_name_hint => 'Tu nombre';

  @override
  String get get_started => 'Empezar';

  @override
  String get select_language => 'Seleccionar idioma';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_notification => 'Notificación';

  @override
  String get settings_dark_mode => 'Modo oscuro';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_currency => 'Moneda';

  @override
  String get settings_smart_sms_capture => 'Captura inteligente de SMS';

  @override
  String get settings_smart_sms_capture_subtitle =>
      'Registrar gastos automáticamente desde SMS bancarios y UPI';

  @override
  String get settings_sms_parser_debug => 'Probar analizador de SMS [Debug]';

  @override
  String get sms_permission_denied =>
      'Se requiere permiso de SMS para capturar transacciones';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_support => 'Soporte';

  @override
  String get settings_secure_data => 'Datos seguros';

  @override
  String get settings_reset_app => 'Reiniciar aplicación';

  @override
  String get settings_reset_alert_title => '¡¡¡Alerta!!!';

  @override
  String get settings_reset_alert_subtitle =>
      'Todos los detalles de las transacciones serán eliminados.\n\n¿Desea continuar?';

  @override
  String get add_transaction_title => 'Añadir transacción';

  @override
  String get edit_transaction_title => 'Editar transacción';

  @override
  String get transaction_type => 'Tipo de transacción';

  @override
  String get transaction_type_expense => 'Gasto';

  @override
  String get transaction_type_income => 'Ingreso';

  @override
  String get transaction_amount => 'Cantidad';

  @override
  String get transaction_amount_hint => 'Introduce la cantidad';

  @override
  String get transaction_date => 'Fecha';

  @override
  String get transaction_categories => 'Categorías';

  @override
  String get transaction_category_hint => 'Seleccionar categoría';

  @override
  String get transaction_no_categories => 'No hay categorías disponibles';

  @override
  String get transaction_notes => 'Notas';

  @override
  String get transaction_notes_hint => 'Introduce notas';

  @override
  String get transaction_record_button => 'Registrar';

  @override
  String get transaction_update_button => 'Actualizar';

  @override
  String get error_enter_amount => 'Por favor, introduce una cantidad';

  @override
  String get error_valid_number => 'Introduce un número válido';

  @override
  String get error_select_category => 'Por favor, selecciona una categoría';

  @override
  String get home_title => 'Inicio';

  @override
  String get transactions_title => 'Transacciones';

  @override
  String get budget_title => 'Presupuesto';

  @override
  String get analytics_title => 'Analítica';

  @override
  String get home_greeting_prefix => 'Hola';

  @override
  String get total_balance_title => 'Salida total';

  @override
  String get balance_is_zero => 'es cero';

  @override
  String get balance_overspent => 'Exceso de gasto';

  @override
  String get this_month_toggle => 'Este mes';

  @override
  String get higher_than_last_month => 'mayor comparado con el mes pasado';

  @override
  String get compared_to_last_month => 'comparado con el mes pasado';

  @override
  String get earnings_label => 'Ganancias';

  @override
  String get spendings_label => 'Gastos';

  @override
  String get you_saved_prefix => 'Ahorraste';

  @override
  String get extra_saved_suffix => 'extra';

  @override
  String get greeting_morning => 'Buenos días';

  @override
  String get greeting_afternoon => 'Buenas tardes';

  @override
  String get greeting_evening => 'Buenas noches';

  @override
  String get spending_cycle_label => 'Ciclo de gastos';

  @override
  String get app_name => 'mono';

  @override
  String get edit_budget_title => 'Editar presupuesto mensual';

  @override
  String get set_budget_title => 'Establecer presupuesto mensual';

  @override
  String get plan_spending_subtitle => 'Planifica tus gastos para este mes';

  @override
  String get allocate_by_category => 'Asignar por categoría';

  @override
  String get no_expense_categories => 'No se encontraron categorías de gastos.';

  @override
  String get total_monthly_budget_label => 'Presupuesto mensual total';

  @override
  String get recommended_budget_hint => 'Recomendado: 70–80% de los ingresos';

  @override
  String get over_budget_label => 'Exceso de presupuesto';

  @override
  String get remaining_to_allocate_label => 'Restante por asignar';

  @override
  String get update_budget_button => 'Actualizar presupuesto';

  @override
  String get save_budget_button => 'Guardar presupuesto';

  @override
  String get budget_category_allocation_title =>
      'Asignación de presupuesto por categoría';

  @override
  String get budget_category_allocation_subtitle =>
      'Asigna tu presupuesto entre diferentes categorías';

  @override
  String get budget_category_allocation_remaining => 'Restante';

  @override
  String get budget_category_allocation_spent => 'Gastado';

  @override
  String get budget_category_allocation_budgeted => 'Presupuestado';

  @override
  String get budget_category_allocation_no_categories =>
      'No hay categorías para asignar presupuesto';

  @override
  String get budget_category_allocation_save_button => 'Guardar asignación';

  @override
  String get analytics_chart_title_expense_trend => 'Tendencia de gastos';

  @override
  String get analytics_chart_title_net_worth => 'Patrimonio neto';

  @override
  String get analytics_chart_title_asset_allocation => 'Asignación de activos';

  @override
  String get analytics_chart_title_budget_discipline =>
      'Disciplina presupuestaria';

  @override
  String get no_expense_data => 'No hay datos de gastos';

  @override
  String get no_data_available => 'No hay datos disponibles';

  @override
  String get no_asset_data => 'No hay datos de activos';

  @override
  String get no_budget_data => 'No hay datos de presupuesto';

  @override
  String get budget_tooltip => 'Presupuesto: ';

  @override
  String get spent_tooltip => 'Gastado: ';

  @override
  String get first_time_budget_title =>
      'Planifica tu dinero de forma más inteligente';

  @override
  String get first_time_budget_subtitle =>
      'Crea tu primer presupuesto mensual para realizar un seguimiento de los gastos y mantener el control.';

  @override
  String get first_time_budget_button => 'Establecer presupuesto mensual';

  @override
  String get first_time_goal_title => 'Para qué estás trabajando';

  @override
  String get first_time_goal_subtitle =>
      'Convierte tus sueños en metas alcanzables';

  @override
  String get first_time_goal_button => 'Empezar a soñar';

  @override
  String get first_time_goal_title_expanded =>
      'Seguimiento inteligente de objetivos';

  @override
  String get first_time_goal_feature_1 => 'Recomendaciones de ahorro mensual.';

  @override
  String get first_time_goal_feature_2 => 'Fechas de finalización proyectadas.';

  @override
  String get first_time_goal_feature_3 => 'Celebraciones de hitos.';

  @override
  String get first_time_goal_feature_4 =>
      'Seguimiento del progreso en tiempo real.';

  @override
  String get first_time_goal_coming_soon =>
      'Pronto llegarán funciones de riqueza';

  @override
  String get first_time_asset_title => 'Vigila tus activos';

  @override
  String get first_time_asset_subtitle =>
      'Añade lo que posees para comprender tu patrimonio neto';

  @override
  String get first_time_asset_button => 'Añadir activos';

  @override
  String get first_time_asset_title_expanded =>
      'Seguimiento de activos y patrimonio neto';

  @override
  String get first_time_asset_feature_1 =>
      'Gráfico de crecimiento del patrimonio neto';

  @override
  String get first_time_asset_feature_2 => 'Desglose de asignación de activos';

  @override
  String get first_time_asset_feature_3 => 'Información de crecimiento mensual';

  @override
  String get first_time_asset_feature_4 =>
      'Seguimiento de la riqueza a largo plazo';

  @override
  String get first_time_asset_notification => 'Notificarme cuando se lance';

  @override
  String get hide_button => 'Ocultar';

  @override
  String get show_button => 'Mostrar';

  @override
  String get recent_transactions => 'Transacciones Recientes';

  @override
  String get filter_all => 'Todo';

  @override
  String get filter_today => 'Hoy';

  @override
  String get filter_weekly => 'Semanal';

  @override
  String get filter_monthly => 'Mensual';

  @override
  String get filter_custom => 'Personalizado';

  @override
  String get action_edit => 'Editar';

  @override
  String get action_delete => 'Eliminar';

  @override
  String get message_deleted => 'Eliminado';

  @override
  String get financial_hub_title => 'Centro Financiero';

  @override
  String get financial_hub_subtitle =>
      'Tu presupuesto, activos y sueños, todo en un solo lugar';

  @override
  String get about_title => 'Acerca de';

  @override
  String get section_legal => 'Legal';

  @override
  String get privacy_policy => 'Política de Privacidad';

  @override
  String get terms_of_service => 'Términos de Servicio';

  @override
  String get section_community => 'Comunidad';

  @override
  String get rate_the_app => 'Calificar la Aplicación';

  @override
  String get share_with_friends => 'Compartir con Amigos';

  @override
  String get share_text =>
      '¡Echa un vistazo a la aplicación Mono para una mejor gestión del dinero! https://example.com/monoapp';

  @override
  String get app_tagline => 'Conoce tus gastos. Haz crecer tus ahorros.';

  @override
  String get version_loading => 'Versión ...';

  @override
  String version_display(Object buildNumber, Object version) {
    return 'Versión $version ($buildNumber)';
  }

  @override
  String get made_with_love => 'Hecho con ❤️ para mejores hábitos de dinero';

  @override
  String get support_title => 'Soporte';

  @override
  String get need_help_title => '¿Necesitas Ayuda?';

  @override
  String get need_help_subtitle =>
      'Estamos aquí para ayudar a mejorar tu experiencia.';

  @override
  String get contact_support => 'Contactar Soporte';

  @override
  String get support_request_title =>
      'Solicitud de Soporte de la Aplicación Mono';

  @override
  String get support_request_body =>
      'Versión de la aplicación:\nDispositivo:\nVersión de Android:\n\nDescribe tu problema aquí...';

  @override
  String get report_bug => 'Reportar un Error';

  @override
  String get bug_report_title => 'Informe de Error de la Aplicación Mono';

  @override
  String get bug_report_body =>
      'Versión de la aplicación:\nDispositivo:\nVersión de Android:\n\nPasos para reproducir:\n1.\n2.\n3.\n\nResultado esperado:\nResultado real:';

  @override
  String get request_feature => 'Sugerir Función';

  @override
  String get feature_request_title =>
      'Sugerencia de Función de la Aplicación Mono';

  @override
  String get feature_request_body =>
      'Sugerencia de función:\n\n¿Por qué te ayudaría esto?';

  @override
  String get error_send_message => 'No se pudo enviar el mensaje';

  @override
  String get budget_overview_title => 'Presupuesto Mensual';

  @override
  String budget_set_for(String month) {
    return 'Presupuesto establecido para $month';
  }

  @override
  String get budget_limit_exceeded => '¡Has superado tu presupuesto mensual!';

  @override
  String get budget_limit_warning =>
      'Advertencia: Te estás acercando al límite de tu presupuesto.';

  @override
  String get budget_label_budget => 'Presupuesto';

  @override
  String get budget_label_spending => 'Gasto';

  @override
  String get budget_label_remaining => 'Restante';

  @override
  String get categories_title => 'Categorías';

  @override
  String get home_empty_state_title => 'Comienza tu viaje financiero';

  @override
  String get home_empty_state_subtitle =>
      'Agrega tu primera transacción para comenzar a rastrear tu dinero.';

  @override
  String get home_empty_state_footer =>
      'Tus datos están encriptados de forma segura.';

  @override
  String get insight_budget_warning_title => 'Casi allí';

  @override
  String insight_budget_warning_message(String amount) {
    return 'Solo te quedan $amount en tu presupuesto.';
  }

  @override
  String get insight_budget_safe_title => 'En camino';

  @override
  String insight_budget_safe_message(String amount) {
    return 'Estás $amount por debajo del presupuesto. Sigue así.';
  }

  @override
  String get insight_budget_exceeded_title => 'Alerta de presupuesto';

  @override
  String insight_budget_exceeded_message(String amount) {
    return 'Has superado tu presupuesto por $amount';
  }

  @override
  String get insight_no_budget_title => 'Planifica con anticipación';

  @override
  String get insight_no_budget_message =>
      'Establece un presupuesto mensual para ayudar a controlar tus gastos.';

  @override
  String get insight_smart_tip_title => 'Consejo inteligente';

  @override
  String insight_smart_tip_message(String amount) {
    return 'Para mantenerte en el camino, mantén el gasto de hoy por debajo de $amount';
  }

  @override
  String get insight_savings_title => 'Actualización de ahorros';

  @override
  String insight_savings_message(String amount) {
    return 'Has ahorrado $amount en lo que va del mes.';
  }

  @override
  String get insight_default_title => 'Todo bien';

  @override
  String get insight_default_message =>
      'Tu actividad financiera parece estable.';

  @override
  String get home_empty_info_text =>
      'How it works: Enter your daily expenses, and we\'ll help you understand your spending habits. No bank connections, no automatic deductions.';

  @override
  String get home_empty_verified_info =>
      'Personal budget planner - never syncs to your bank.';

  @override
  String get home_empty_privacy_info1 =>
      'You control every entry - nothing is automatic.';

  @override
  String get home_empty_privacy_info2 =>
      'See spending patterns - make informed decisions.';

  @override
  String get home_empty_privacy_info3 =>
      'We never sell or share your personal data.';

  @override
  String get add_first_expense => 'Add Your First Expense';

  @override
  String get goal_details_title => 'Detalles del objetivo';

  @override
  String get edit_goal_title => 'Editar objetivo';

  @override
  String get add_money_title => 'Agregar dinero';

  @override
  String get add_money_button => '+ Agregar dinero';

  @override
  String get goals_in_progress => 'In Progress';

  @override
  String get goals_completed => 'Completed';

  @override
  String get goals_empty_state => 'No goals in this category.';

  @override
  String get saved_label => 'Ahorrado';

  @override
  String get remaining_label => 'Restante';

  @override
  String get target_amount_label => 'Monto objetivo';

  @override
  String get target_date_label => 'Fecha objetivo';

  @override
  String get progress_label => 'Progreso';

  @override
  String get contribution_history_title => 'Historial de contribuciones';

  @override
  String get no_contributions_yet => 'Aún no hay contribuciones guardadas.';

  @override
  String get delete_goal_title => 'Eliminar objetivo';

  @override
  String get delete_goal_confirmation =>
      '¿Estás seguro de que deseas eliminar este objetivo? Esta acción no se puede deshacer.';

  @override
  String get amount_required_error => 'Por favor ingresa un monto';

  @override
  String get amount_greater_than_zero_error => 'El monto debe ser mayor que 0';

  @override
  String get amount_exceeds_remaining_warning =>
      'El monto excede el objetivo restante';

  @override
  String get update_goal_button => 'Actualizar objetivo';
}
