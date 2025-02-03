
  

# CieID-iOS-sdk

  

**CieID-iOS-sdk**  è un kit di sviluppo software (SDK) per dispositivi iOS, sviluppato in  **Swift**, che offre le funzionalità di autenticazione tramite il servizio  **“Entra con CIE”**. Questo SDK consente agli sviluppatori di integrare facilmente l’autenticazione basata sulla  **Carta d’Identità Elettronica (CIE 3.0)**  all’interno delle proprie applicazioni iOS, garantendo un accesso sicuro e conforme agli standard di identità digitale.

  

# Requisiti tecnici

  

**CieID-iOS-sdk**  richiede dispositivi iOS con  **iOS 13.0**  o versioni successive. Per utilizzare le funzionalità dell’SDK, è necessario uno smartphone compatibile con la tecnologia  **NFC**, come gli  **iPhone 7**  o modelli successivi. Tuttavia, l’SDK  **non è compatibile con iPhone SE di prima generazione (modello 2016)**, poiché questo dispositivo non supporta la tecnologia NFC.

  

# Requisiti di integrazione

  

Per integrare il  **CieID-iOS-sdk**, è necessario che l’integratore sia un  **Service Provider federato**  e che abbia implementato la tecnologia necessaria per abilitare il flusso di autenticazione tramite  **“Entra con CIE”**. Questo richiede la conformità agli standard tecnici e operativi previsti per l’interoperabilità con il sistema di autenticazione basato sulla  **Carta d’Identità Elettronica (CIE)**.

Per una guida completa all’integrazione e ai requisiti tecnici, consulta il  [Manuale per Service Provider](https://www.cartaidentita.interno.gov.it/CIE3.0-ManualeSP.pdf).



# Come si usa




Attualmente, il kit supporta esclusivamente il flusso di autenticazione con  **reindirizzamento**, descritto nei passi seguenti. L’integrazione è semplice e richiede solo pochi passaggi fondamentali:

1.  **Importazione del kit nel progetto**

Aggiungi il framework  **CieID-iOS-sdk**  al tuo progetto per iniziare l’integrazione.

2.  **Configurazione dell’URL Scheme**

Imposta un URL Scheme personalizzato nel file di configurazione del progetto per gestire il reindirizzamento.

3.  **Configurazione dell’URL di un Service Provider valido**

Aggiorna il file  Info.plist  con l’URL del Service Provider federato, necessario per il corretto funzionamento del flusso di autenticazione.

4.  **Aggiunta dello Smart Button “Entra con CIE”**

Integra lo  **Smart Button**  nella tua interfaccia utente tramite lo storyboard per avviare il flusso di autenticazione.

5.  **Inizializzazione e presentazione della WebView di autenticazione**

Configura e presenta una  **WebView**  per eseguire il login e completare l’autenticazione tramite il portale del Service Provider.

6.  **Gestione dei Delegati**

Implementa i metodi delegati forniti dall’SDK per monitorare gli eventi chiave, come il completamento dell’autenticazione o eventuali errori.

  

## Flusso con reindirizzamento

Il flusso di autenticazione con  **reindirizzamento**  consente a un  **Service Provider accreditato**  di integrare l’autenticazione  **Entra con CIE** all’interno della propria applicazione iOS. Questo approccio delega le operazioni di autenticazione all’app ufficiale  **CieID**, semplificando l’implementazione per il Service Provider e garantendo la conformità agli standard di sicurezza.

  

Per utilizzare questo flusso, è necessario che l’utente abbia installata sul proprio smartphone l’app  **CieID**  nella  **versione 1.2.1 o successiva**. Questa versione include tutte le funzionalità necessarie per supportare il flusso di autenticazione basato sulla Carta d’Identità Elettronica (CIE) in ambiente mobile.

  

## Flusso interno

Non disponibile in questa versione.

  

## Importazione

  

Per integrare il kit all’interno del tuo progetto  **XCode**, segui questi passaggi:

1.  Individua la cartella denominata  **CieIDsdk**  nel file system locale.

2.  Trascina la cartella  **CieIDsdk**  direttamente nella sezione  **Project Navigator**  di Xcode (solitamente situata nella barra laterale sinistra).

3.  Quando viene visualizzata la finestra di dialogo, assicurati di:

•  **Selezionare l’opzione “Copy items if needed”**  per copiare i file nel progetto.

•  Verificare che la cartella sia inclusa nel target corretto del tuo progetto.

4.  Fai clic su  **Finish**  per completare l’aggiunta.

Questo processo importerà correttamente tutti i file necessari e configurerà il progetto per l’utilizzo del  **CieIDsdk**.

  

## Configurazione URL Scheme

  


Nel flusso di autenticazione con  **reindirizzamento**, l’applicazione  **CieID**  deve essere in grado di aprire l’app chiamante per notificare l’esito dell’autenticazione. Per abilitare questa comunicazione, è necessario configurare un  **URL Scheme**  all’interno del progetto Xcode seguendo i passaggi riportati di seguito:

  

**Configurazione dell’URL Scheme**

1.  Apri il progetto in  **Xcode**.

2.  Seleziona il  **Target**  dell’applicazione.

3.  Vai al pannello  **Info**  e scorri fino alla sezione  **URL Types**.

4.  Clicca sul pulsante “+” per aggiungere un nuovo URL Type.

5.  Compila i campi richiesti:

•  **Identifier**: Inserisci un identificatore univoco (ad esempio, il  **Bundle Identifier**  dell’app).

•  **URL Scheme**: Inserisci il valore desiderato per il tuo URL Scheme (esempio:  com.tuoapp).

•  **Role**: Imposta questo campo su  **None**.

  

**Aggiornamento del file Info.plist**

  

Il valore inserito nel campo  **URL Scheme**  deve essere riportato anche nel file  **Info.plist**  per consentire la corretta configurazione del flusso. Aggiungi un nuovo parametro chiamato  **SP_URL_SCHEME**  di tipo  **String**, e assegna ad esso lo stesso valore dell’URL Scheme configurato in precedenza.

  

Esempio di configurazione nel file  **Info.plist**:

  

```xml
<key>SP_URL_SCHEME</key>
<string>com.tuoapp</string>
```

  

Una volta che l’app viene riaperta dal flusso di autenticazione, la  **WebView**  deve ricevere un nuovo URL e continuare la navigazione per completare il processo. Per gestire questo passaggio, è necessario implementare la logica di gestione degli URL all’interno del file  **SceneDelegate**  utilizzando il metodo  **openUrlContext**.

  

Di seguito viene riportato un esempio di implementazione del metodo  **openUrlContext**, che dovrà essere importato nel file  **SceneDelegate**:

  

```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
	guard let url = URLContexts.first?.url else { return }
	var urlString : String = String(url.absoluteString)
	if let httpsRange = urlString.range(of: "https://") {

	//Rimozione del prefisso dell'URL SCHEME
	let startPos = urlString.distance(from: urlString.startIndex, to: httpsRange.lowerBound)
	urlString = String(urlString.dropFirst(startPos))

	//Passaggio dell'URL alla WebView
	let response : [String:String] = ["payload": urlString]
	let NOTIFICATION_NAME : String = "RETURN_FROM_CIEID"
	
	NotificationCenter.default.post(name: Notification.Name(NOTIFICATION_NAME), object: nil, userInfo: response)

	}
}

```

  

## Configurazione Service Provider URL

  

Entrambi i flussi di autenticazione sono avviati tramite l’utilizzo di una  **WebView**. Per questo motivo, è necessario configurare correttamente l’URL della pagina web del  **Service Provider**  (SP) che integra il pulsante  **“Entra con CIE”**.

Questa configurazione viene effettuata aggiungendo l’URL dell’ambiente di produzione del Service Provider nel file  **Info.plist**. Il parametro da aggiungere deve essere denominato  **SP_URL**  ed essere di tipo  **String**.

**Configurazione nel file Info.plist**

Ecco un esempio di configurazione:

  

```xml
<key>SP_URL</key>
<string>https://www.tuoserviceprovider.it/autenticazione</string>
```

  

## Importazione del pulsante Entra con CIE

  

Per integrare il pulsante ufficiale  **“Entra con CIE”**  nella tua interfaccia, segui questi semplici passaggi:

  

**Configurazione del Pulsante nello Storyboard**

1.  **Aggiungi un UIButton nello Storyboard**

•  Apri il file  **Main.storyboard**  (o il file dello storyboard che desideri modificare).

•  Trascina un oggetto di tipo  **UIButton**  nella tua scena o nella posizione desiderata.

2.  **Assegna la Classe Personalizzata**

•  Con il pulsante selezionato, apri il pannello  **Identity Inspector**  nella barra laterale destra di Xcode.

•  Nella sezione  **Class**, imposta la classe personalizzata su  **CieIDButton**.

3.  **Rendering Automatico**

•  Dopo aver impostato la classe, il pulsante verrà automaticamente renderizzato con lo stile ufficiale del pulsante  **“Entra con CIE”**. Non sarà necessario aggiungere ulteriori configurazioni grafiche.

  

**Personalizzazione (Opzionale)**

•  Puoi utilizzare  **Auto Layout**  o  **Constraints**  per posizionare il pulsante e adattarlo dinamicamente alla tua interfaccia utente.

•  Assicurati che il pulsante sia ben visibile e accessibile, rispettando le linee guida di usabilità e accessibilità di iOS.

  

**Nota Importante**

•  La classe  **CieIDButton**  gestisce automaticamente gli eventi e il comportamento del pulsante, semplificando l’integrazione con il flusso di autenticazione. Tuttavia, è possibile aggiungere metodi personalizzati o delegati per gestire azioni specifiche in risposta all’interazione dell’utente.

  

## Eseguire l'autenticazione

  

Di seguito è riportato un esempio di gestione dell’evento  **TouchUpInside**  associato al pulsante  **“Entra con CIE”**, che permette di inizializzare e presentare la  **WebView**  per avviare il flusso di autenticazione.

  

**Esempio di Implementazione**

  

```swift

@IBAction func  startAuthentication(_ sender: UIButton) {
	let cieIDAuthenticator = CieIDWKWebViewController()
	cieIDAuthenticator.modalPresentationStyle = .fullScreen
	cieIDAuthenticator.setupDelegate(delegate: self, and: .Redirect, and: .Default)
	present(cieIDAuthenticator, animated: true, completion: nil)
}
```

  

La classe chiamante deve conformarsi al protocollo  **CieIdDelegate**  per gestire correttamente gli eventi e le comunicazioni provenienti dal flusso di autenticazione. Questo consente di monitorare lo stato dell’autenticazione e di implementare azioni personalizzate in base agli esiti.

  

**Implementazione del Protocollo**

  

Di seguito è riportato un esempio di come conformare una classe al protocollo  **CieIdDelegate**:

  

```swift
class  ExampleViewController: UIViewController, CieIdDelegate {
...
}

```

  

L'utente potrà navigare nella webView mostrata che lo indirizzerà sull'app CieID dove potrà eseguire l'autenticazione con la Carta di Identità Elettronica, al termine verrà nuovamente reindirizzato sull'app chiamante in cui potrà dare il consenso alla condivisione delle informazioni personali e portare al termine l'autenticazione.

  

Al termine dell'autenticazione verrà chiamato il delegato ****CieIDAuthenticationClosedWithSuccess****. La chiamata di questo delegato proviene dalla classe ****CieIDWKWebViewController****. Potrebbe rendersi necessario posticipare la chiamata di questo delegato in base alla logica di autenticazione del Service Provider.

  

## Gestione eventi

  

Il protocollo richiede la gestione dei seguenti eventi attraverso i metodi delegati, che consentono di monitorare e controllare il flusso di autenticazione con  **“Entra con CIE”**:

  

**Eventi Gestiti dal Protocollo**

1.  **Autenticazione completata con successo**

•  **Metodo**: func authenticationDidSucceed(userInfo: [String: Any])

•  **Descrizione**: Viene chiamato quando il processo di autenticazione è completato correttamente. Contiene i dati utente restituiti dal Service Provider, che possono essere utilizzati per aggiornare l’interfaccia utente o per eseguire altre operazioni personalizzate.

2.  **Errore durante l’autenticazione**

•  **Metodo**: func authenticationDidFail(error: Error)

•  **Descrizione**: Notifica che si è verificato un errore durante il flusso di autenticazione. Puoi gestire il problema (ad esempio, una connessione non riuscita o un errore lato server) e fornire feedback appropriato all’utente.

3.  **Autenticazione annullata dall’utente**

•  **Metodo**: func authenticationWasCancelled()

•  **Descrizione**: Segnala che l’utente ha annullato il processo di autenticazione, permettendo di gestire il ripristino dello stato dell’applicazione o di reimpostare l’interfaccia.

  

**Implementazione dei Metodi Delegati**

  

Esempio pratico di implementazione:

  

```swift
func  CieIDAuthenticationClosedWithSuccess() {
	print("Authentication closed with SUCCESS")
}
```

```swift
func  CieIDAuthenticationCanceled() {
	print("L'utente ha annullato l'operazione")
}
```

```swift
func  CieIDAuthenticationClosedWithError(errorMessage: String) {
	print("ERROR MESSAGE: \(errorMessage)")
}

```



**Gestione delle Navigazioni in WKWebView**

  

È possibile avere una diversa gestione delle navigazioni in  **WKWebView**  attraverso l’implementazione del metodo delegato  webView(_:decidePolicyFor:decisionHandler:). Questo metodo consente di controllare il comportamento delle richieste di navigazione in base a due distinte modalità operative (**Universal**  o **Default**).

  

**Descrizione del Metodo**

  

Il metodo analizza l’URL della richiesta di navigazione e decide come procedere in base ai seguenti criteri:

•  **Modalità Universal**: Specifica una serie di condizioni per gestire il flusso interno o reindirizzare in base a specifici pattern URL. Da usare se si preferisce gestire l'apertura ed il ritorno all'applicazione chiamante tramite lo universal link.

•  **Modalità Normale**: Utilizza un set di regole leggermente diverso per gestire le navigazioni, includendo controlli per percorsi specifici.

Entrambe le modalità sono progettate per garantire un flusso di autenticazione sicuro ed efficace, lasciando libertà di scelta in base alle esigenze del progetto.

  

**Esempio di Implementazione**
```swift
public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {

    guard let url = navigationAction.request.url else { return }
    let string = url.absoluteString
    let path = url.pathComponents

    if self.mode == .Universal {
        if ((string.containsValidIdpUrl && string.contains("idp/login/app") && string.contains("level=2")) || 
            (string.containsValidIdpUrl && string.contains("nextUrl")) || 
            path.contains("livello1")) {
            ...
            decisionHandler(.cancel)
            return
        }
    } else {
        if ((string.containsValidIdpUrl && string.contains("nextUrl")) || 
            path.contains("livello1") || 
            path.contains("livello2")) {
            ...
            decisionHandler(.cancel)
            return
        }
    }

    ...

    decisionHandler(.allow)
}
```


# Licenza

Il codice sorgente di questo progetto è distribuito sotto la licenza  **BSD-3-Clause**  (codice SPDX: BSD-3-Clause), una licenza permissiva che consente l’uso, la modifica e la distribuzione del codice sorgente, a condizione che vengano rispettati i termini della licenza.

  

**Informazioni sulla Licenza BSD-3-Clause**

•  **Permessi**:

Uso commerciale.

Modifiche e adattamenti.

Distribuzione, sia in formato sorgente che binario.

•  **Obblighi**:

Includere i termini della licenza originale e le note di copyright in tutte le copie o distribuzioni.

Non utilizzare i nomi degli autori o i contributori per promuovere prodotti derivati senza autorizzazione.

•  **Limitazioni**:

Nessuna garanzia: il codice è fornito “così com’è”, senza garanzia di alcun tipo, implicita o esplicita.

  

**Maggiori Dettagli**

  

Per ulteriori informazioni sui termini della licenza visita la pagina ufficiale  [Open Source Initiative BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
